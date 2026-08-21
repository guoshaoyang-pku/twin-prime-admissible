import Sound
import lean_certs.cert_9_22

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H9_gt_22_kernel : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 9) (d := 22) (c := cert_9_22) (by decide)
