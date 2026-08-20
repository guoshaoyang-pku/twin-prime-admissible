import Sound
import lean_certs.cert_38_122

open CertVerify

theorem H38_gt_122 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 38) (d := 122) (c := cert_38_122) (by native_decide)
