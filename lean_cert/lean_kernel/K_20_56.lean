import Sound
import lean_certs.cert_20_56

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_56_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 20) (d := 56) (c := cert_20_56) (by decide)
