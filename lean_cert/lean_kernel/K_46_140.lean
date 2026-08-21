import Sound
import lean_certs.cert_46_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_140_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 46) (d := 140) (c := cert_46_140) (by decide)
