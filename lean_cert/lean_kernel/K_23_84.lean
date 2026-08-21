import Sound
import lean_certs.cert_23_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_84_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 23) (d := 84) (c := cert_23_84) (by decide)
