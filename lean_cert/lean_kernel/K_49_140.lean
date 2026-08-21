import Sound
import lean_certs.cert_49_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_140_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 49) (d := 140) (c := cert_49_140) (by decide)
