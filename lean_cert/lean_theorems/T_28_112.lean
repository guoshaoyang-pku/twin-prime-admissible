import Sound
import lean_certs.cert_28_112

open CertVerify

theorem H28_gt_112 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 28) (d := 112) (c := cert_28_112) (by native_decide)
