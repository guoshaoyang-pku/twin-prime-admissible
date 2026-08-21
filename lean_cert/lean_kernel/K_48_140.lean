import Sound
import lean_certs.cert_48_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_140_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 48) (d := 140) (c := cert_48_140) (by decide)
