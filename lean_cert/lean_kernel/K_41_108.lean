import Sound
import lean_certs.cert_41_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_108_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 41) (d := 108) (c := cert_41_108) (by decide)
