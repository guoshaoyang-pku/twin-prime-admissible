import Sound
import lean_certs.cert_49_200

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_200_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 49) (d := 200) (c := cert_49_200) (by decide)
