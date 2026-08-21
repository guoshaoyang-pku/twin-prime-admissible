import Sound
import lean_certs.cert_32_122

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_122_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 122 := by
  exact certValidRoot_sound (k := 32) (d := 122) (c := cert_32_122) (by decide)
