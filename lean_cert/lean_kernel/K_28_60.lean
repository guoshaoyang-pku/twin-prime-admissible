import Sound
import lean_certs.cert_28_60

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_60_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 60 := by
  exact certValidRoot_sound (k := 28) (d := 60) (c := cert_28_60) (by decide)
