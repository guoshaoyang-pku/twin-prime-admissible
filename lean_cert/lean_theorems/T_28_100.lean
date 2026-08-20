import Sound
import lean_certs.cert_28_100

open CertVerify

theorem H28_gt_100 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 28) (d := 100) (c := cert_28_100) (by native_decide)
