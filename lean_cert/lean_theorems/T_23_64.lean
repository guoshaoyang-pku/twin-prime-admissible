import Sound
import lean_certs.cert_23_64

open CertVerify

theorem H23_gt_64 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 23) (d := 64) (c := cert_23_64) (by native_decide)
