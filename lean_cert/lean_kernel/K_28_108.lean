import Sound
import lean_certs.cert_28_108

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_108_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 28) (d := 108) (c := cert_28_108) (by decide)
