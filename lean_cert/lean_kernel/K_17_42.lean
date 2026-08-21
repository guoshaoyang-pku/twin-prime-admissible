import Sound
import lean_certs.cert_17_42

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_42_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 42 := by
  exact certValidRoot_sound (k := 17) (d := 42) (c := cert_17_42) (by decide)
