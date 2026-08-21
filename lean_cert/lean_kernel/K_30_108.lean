import Sound
import lean_certs.cert_30_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_108_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 30) (d := 108) (c := cert_30_108) (by decide)
