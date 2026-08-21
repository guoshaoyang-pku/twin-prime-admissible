import Sound
import lean_certs.cert_12_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H12_gt_34_kernel : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 12) (d := 34) (c := cert_12_34) (by decide)
