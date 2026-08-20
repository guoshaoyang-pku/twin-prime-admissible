import Sound
import lean_certs.cert_20_48

open CertVerify

theorem H20_gt_48 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 20) (d := 48) (c := cert_20_48) (by native_decide)
