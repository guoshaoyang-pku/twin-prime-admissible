import Sound
import lean_certs.cert_41_90

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_90_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 41) (d := 90) (c := cert_41_90) (by decide)
