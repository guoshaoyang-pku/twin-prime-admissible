import Sound
import lean_certs.cert_49_204

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_204_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 204 := by
  exact certValidRoot_sound (k := 49) (d := 204) (c := cert_49_204) (by decide)
