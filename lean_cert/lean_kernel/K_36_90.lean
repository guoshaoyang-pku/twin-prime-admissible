import Sound
import lean_certs.cert_36_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_90_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 36) (d := 90) (c := cert_36_90) (by decide)
