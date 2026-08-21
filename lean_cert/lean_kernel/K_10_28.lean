import Sound
import lean_certs.cert_10_28

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H10_gt_28_kernel : ¬ ∃ t : List Nat, admissible 10 t = true ∧ diameter t ≤ 28 := by
  exact certValidRoot_sound (k := 10) (d := 28) (c := cert_10_28) (by decide)
