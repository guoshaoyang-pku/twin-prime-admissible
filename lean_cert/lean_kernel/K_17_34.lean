import Sound
import lean_certs.cert_17_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H17_gt_34_kernel : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 17) (d := 34) (c := cert_17_34) (by decide)
