import Sound
import lean_certs.cert_41_112

open CertVerify

theorem H41_gt_112 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 41) (d := 112) (c := cert_41_112) (by native_decide)
