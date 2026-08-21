import Sound
import lean_certs.cert_46_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_108_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 46) (d := 108) (c := cert_46_108) (by decide)
