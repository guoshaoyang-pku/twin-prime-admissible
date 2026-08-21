import Sound
import lean_certs.cert_41_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_122_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 41) (d := 122) (c := cert_41_122) (by decide)
