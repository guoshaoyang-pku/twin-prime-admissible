import Sound
import lean_certs.cert_14_32

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H14_gt_32_kernel : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 32 := by
  exact certValidRoot_sound (k := 14) (d := 32) (c := cert_14_32) (by decide)
