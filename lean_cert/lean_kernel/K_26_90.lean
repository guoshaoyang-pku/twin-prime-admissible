import Sound
import lean_certs.cert_26_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H26_gt_90_kernel : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 26) (d := 90) (c := cert_26_90) (by decide)
