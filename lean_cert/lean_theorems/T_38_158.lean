import Sound
import lean_certs.cert_38_158

open CertVerify

theorem H38_gt_158 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 38) (d := 158) (c := cert_38_158) (by native_decide)
