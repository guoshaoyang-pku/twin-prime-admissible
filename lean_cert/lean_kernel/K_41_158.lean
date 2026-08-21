import Sound
import lean_certs.cert_41_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_158_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 41) (d := 158) (c := cert_41_158) (by decide)
