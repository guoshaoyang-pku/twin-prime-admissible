import Sound
import lean_certs.cert_31_102

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_102_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 102 := by
  exact certValidRoot_sound (k := 31) (d := 102) (c := cert_31_102) (by decide)
