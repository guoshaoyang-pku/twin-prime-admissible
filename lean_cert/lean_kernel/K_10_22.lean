import Sound
import lean_certs.cert_10_22

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H10_gt_22_kernel : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 10) (d := 22) (c := cert_10_22) (by decide)
