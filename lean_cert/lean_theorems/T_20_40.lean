import Sound
import lean_certs.cert_20_40

open CertVerify

theorem H20_gt_40 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 20) (d := 40) (c := cert_20_40) (by native_decide)
