import Sound
import lean_certs.cert_11_22

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H11_gt_22_kernel : ¬ ∃ t : List Nat, admissible 11 t = true ∧ diameter t ≤ 22 := by
  exact certValidRoot_sound (k := 11) (d := 22) (c := cert_11_22) (by decide)
