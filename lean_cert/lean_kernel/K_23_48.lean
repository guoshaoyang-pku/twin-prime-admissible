import Sound
import lean_certs.cert_23_48

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_48_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 23) (d := 48) (c := cert_23_48) (by decide)
