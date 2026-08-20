import Sound
import lean_certs.cert_20_38

open CertVerify

theorem H20_gt_38 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 20) (d := 38) (c := cert_20_38) (by native_decide)
