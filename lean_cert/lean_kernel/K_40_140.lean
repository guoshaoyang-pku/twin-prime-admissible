import Sound
import lean_certs.cert_40_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_140_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 40) (d := 140) (c := cert_40_140) (by decide)
