import Sound
import lean_certs.cert_9_26

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H9_gt_26_kernel : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 9) (d := 26) (c := cert_9_26) (by decide)
