import Sound
import lean_certs.cert_9_16

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H9_gt_16_kernel : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 16 := by
  exact certValidRoot_sound (k := 9) (d := 16) (c := cert_9_16) (by decide)
