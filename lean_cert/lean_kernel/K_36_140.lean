import Sound
import lean_certs.cert_36_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H36_gt_140_kernel : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 36) (d := 140) (c := cert_36_140) (by decide)
