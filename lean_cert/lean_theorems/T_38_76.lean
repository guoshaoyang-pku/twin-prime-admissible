import Sound
import lean_certs.cert_38_76

open CertVerify

theorem H38_gt_76 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 76 := by
  exact certValidRoot_sound (k := 38) (d := 76) (c := cert_38_76) (by native_decide)
