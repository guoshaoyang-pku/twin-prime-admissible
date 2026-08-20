import Sound
import lean_certs.cert_39_122

open CertVerify

theorem H39_gt_122 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 39) (d := 122) (c := cert_39_122) (by native_decide)
