import Sound
import lean_certs.cert_28_64

open CertVerify

theorem H28_gt_64 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 64 := by
  exact certValidRoot_sound (k := 28) (d := 64) (c := cert_28_64) (by native_decide)
