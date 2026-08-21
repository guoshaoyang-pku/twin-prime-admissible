import Sound
import lean_certs.cert_9_28

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H9_gt_28_kernel : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 9) (d := 28) (c := cert_9_28) (by decide)
