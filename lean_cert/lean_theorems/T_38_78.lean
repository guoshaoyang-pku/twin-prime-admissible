import Sound
import lean_certs.cert_38_78

open CertVerify

theorem H38_gt_78 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 38) (d := 78) (c := cert_38_78) (by native_decide)
