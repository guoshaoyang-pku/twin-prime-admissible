import Sound
import lean_certs.cert_41_122

open CertVerify

theorem H41_gt_122 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 41) (d := 122) (c := cert_41_122) (by native_decide)
