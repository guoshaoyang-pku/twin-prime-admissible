import Sound
import lean_certs.cert_26_84

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_84_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 84 := by
  exact certValidRoot_sound (k := 26) (d := 84) (c := cert_26_84) (by decide)
