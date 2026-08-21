import Sound
import lean_certs.cert_9_20

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H9_gt_20_kernel : ¬ ∃ t : List Nat, admissible 9 t = true ∧ diameter t ≤ 20 := by
  exact certValidRoot_sound (k := 9) (d := 20) (c := cert_9_20) (by decide)
