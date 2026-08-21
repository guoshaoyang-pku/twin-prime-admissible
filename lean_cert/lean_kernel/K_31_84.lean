import Sound
import lean_certs.cert_31_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_84_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 31) (d := 84) (c := cert_31_84) (by decide)
