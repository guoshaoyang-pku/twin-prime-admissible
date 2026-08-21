import Sound
import lean_certs.cert_9_18

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H9_gt_18_kernel : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 18 := by
  exact certValidRoot_sound (k := 9) (d := 18) (c := cert_9_18) (by decide)
