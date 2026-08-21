import Sound
import lean_certs.cert_36_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_108_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 36) (d := 108) (c := cert_36_108) (by decide)
