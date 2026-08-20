import Sound
import lean_certs.cert_32_122

open CertVerify

theorem H32_gt_122 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 32) (d := 122) (c := cert_32_122) (by native_decide)
