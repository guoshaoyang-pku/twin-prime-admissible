import Sound
import lean_certs.cert_12_22

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_22_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 12) (d := 22) (c := cert_12_22) (by decide)
