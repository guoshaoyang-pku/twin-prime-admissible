import Sound
import lean_certs.cert_49_112

open CertVerify

theorem H49_gt_112 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 112 := by
  exact certValidRoot_sound (k := 49) (d := 112) (c := cert_49_112) (by native_decide)
