import Sound
import lean_certs.cert_48_112

open CertVerify

theorem H48_gt_112 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 48) (d := 112) (c := cert_48_112) (by native_decide)
